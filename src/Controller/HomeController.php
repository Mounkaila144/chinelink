<?php

namespace App\Controller;

use App\Repository\CategorieRepository;
use App\Repository\ProduitRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(ProduitRepository $produitRepository, CategorieRepository $categorieRepository): Response
    {
        return $this->render('home/index.html.twig', [
            'produits' => $produitRepository->findAll(),
            'categories' => $categorieRepository->findAll(),
            'selectedCategoryId' => null,
        ]);
    }

    #[Route('/filter/{id}', name: 'filter_home')]
    public function filterByCategory(ProduitRepository $produitRepository, CategorieRepository $categorieRepository, $id): Response
    {
        return $this->render('home/index.html.twig', [
            'produits' => $produitRepository->findBy(['categorie' => $id]),
            'categories' => $categorieRepository->findAll(),
            'selectedCategoryId' => $id,
        ]);
    }

}
